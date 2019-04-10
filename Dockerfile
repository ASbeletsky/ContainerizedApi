FROM antonbeletsky/dotnet-debug AS base
WORKDIR /app 
MAINTAINER Vladimir Vladimir@akopyan.me

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src 
COPY ./ContainerizedApi .

RUN dotnet restore  
FROM build AS publish
RUN dotnet publish -c Debug -o /app 

FROM base AS final
COPY --from=publish /app /app
COPY ./StartSSHAndApp.sh /app 
EXPOSE 80 

CMD /app/StartSSHAndApp.sh
#If you wish to only have SSH running and start #your service when you start debugging#then use just the SSH server, you don't need the script
#CMD ["/usr/sbin/sshd", "-D"]