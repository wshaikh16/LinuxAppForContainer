FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["LinuxAppForContainer/LinuxAppForContainer.csproj", "LinuxAppForContainer/"]
RUN dotnet restore "LinuxAppForContainer/LinuxAppForContainer.csproj"
COPY . .
WORKDIR "/src/LinuxAppForContainer"
RUN dotnet build "LinuxAppForContainer.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "LinuxAppForContainer.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "LinuxAppForContainer.dll"]