# Base image from the Red Hat registry that provides a .NET Core 3.1 
# environment you can use to run your .NET application
FROM registry.redhat.io/rhel8/dotnet-31 AS build-env
USER root
WORKDIR /app
# Copy csproj and restore as distinct layers
COPY . .
RUN dotnet restore /app/blogDemo.csproj
# Build assemblies in the out directory
RUN dotnet publish -c Release -o out --no-restore /app/blogDemo.csproj
# Build runtime image
FROM registry.redhat.io/rhel8/dotnet-31-runtime
WORKDIR /app
# Copy solution
COPY --from=build-env /app/out .
USER 1001
ENTRYPOINT ["/usr/bin/dotnet", "blogDemo.dll"]
