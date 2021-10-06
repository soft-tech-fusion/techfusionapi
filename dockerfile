    FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
    WORKDIR /app

    # copy csproj and restore as distinct layers
    COPY *.csproj .

    RUN dotnet restore

    # copy everything else and build app
    COPY . ./aspnetapp/
    WORKDIR /app/aspnetapp

    RUN dotnet publish -c Release -o out

    FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
    WORKDIR /app
    COPY --from=build /app/aspnetapp/out ./

    EXPOSE 8080/tcp
    ENV ASPNETCORE_URLS http://*:8080

    ENTRYPOINT ["dotnet", "techfusionapi.dll"]