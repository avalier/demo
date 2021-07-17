## BUILD ##
FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Avalier.Demo/*.csproj ./Avalier.Demo/
COPY Avalier.Demo.Host/*.csproj ./Avalier.Demo.Host/
COPY Avalier.Demo.Host.Tests/*.csproj ./Avalier.Demo.Host.Tests/
RUN dotnet restore

# copy everything else and build app
COPY Avalier.Demo/ ./Avalier.Demo/
COPY Avalier.Demo.Host/ ./Avalier.Demo.Host/
WORKDIR /app/Avalier.Demo.Host
RUN dotnet publish -c Release -o out -r linux-musl-x64 /p:PublishSingleFile=true /p:PublishTrimmed=true

## RUNTIME ##
FROM mcr.microsoft.com/dotnet/runtime-deps:5.0-alpine AS runtime
WORKDIR /app
ENV HOME=/app
ENV ASPNETCORE_URLS=http://*:5000
#;https://*:5001
RUN apk add curl && addgroup -S app && adduser -S -G app --home "/app" --no-create-home --disabled-password  app
COPY --from=build --chown=app:app /app/Avalier.Demo.Host/out /app

USER app
EXPOSE 5000
ENTRYPOINT /app/Avalier.Demo.Host
#HEALTHCHECK CMD curl --fail http://localhost:5000/api/health || exit


