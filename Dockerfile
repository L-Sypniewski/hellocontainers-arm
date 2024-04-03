FROM mcr.microsoft.com/dotnet/aspnet:7.0-bullseye-slim-arm32v7 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0-bullseye-slim AS build
WORKDIR /src
COPY ["hellocontainers/hellocontainers.csproj", "hellocontainers/"]
RUN dotnet restore "hellocontainers/hellocontainers.csproj"
COPY . .
WORKDIR "/src/hellocontainers"
RUN dotnet build "hellocontainers.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "hellocontainers.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "hellocontainers.dll"]