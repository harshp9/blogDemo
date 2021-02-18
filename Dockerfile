FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
USER root
WORKDIR /app
# Copy csproj and restore as distinct layers
COPY publixDemo.csproj ./
RUN dotnet restore
# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out --no-restore /app/publixDemo.csproj
RUN ls /app/out
# Build runtime image
FROM registry.redhat.io/rhel8/dotnet-31
WORKDIR /app
COPY --from=build-env /app/ .
USER 1001
ENTRYPOINT ["dotnet", "out/publixDemo.dll"]
# CMD while true; do sleep 120 && date; done