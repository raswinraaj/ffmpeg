FROM jrottenberg/ffmpeg  as ffmpeg
WORKDIR /usr/local
RUN ls
RUN ffmpeg -version
FROM mcr.microsoft.com/dotnet/core/runtime:2.1
WORKDIR /app
#RUN ffmpeg -version
COPY --from=ffmpeg /usr/local .
RUN ls
COPY . .
RUN ls
#RUN dotnet --version
RUN /usr/local/ffmpeg -version
# Select non-root port
ENV ASPNETCORE_URLS=http://+:5000
# Do not run as root user
RUN chown -R www-data:www-data /app
USER www-data
HEALTHCHECK --interval=30s --timeout=10s CMD curl -f http://localhost:5000/api/health || exit 1
ENTRYPOINT ["dotnet", "API.dll"]
