# 1: kopiera exekverbara filer i vår image

# 2: köra vår exekverbara fil i vår container

# instruktion för hur image ska konstrueras

# # här säger vilken dotnet version programmet behöver
# FROM mcr.microsoft.com/dotnet/sdk:10.0

# WORKDIR /app

# # kopierar in kompilerade versionen av programmet
# # men man SKA kompilera i containern
# COPY ./bin/Debug/net10.0 .

# # här körs programmet
# CMD["dotnet", "dockerintro.dll"]


# istället - skapa imagen i flera steg
# Steg 1: bygg programmet i en miljö
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src
# fr.o.m nu är /src "där jag är"

# kopiera projektfilen och installera dependencies
# * --> alla .csproj filer oavsett namn
COPY *.csproj ./   
RUN dotnet restore

# kopiera resten av koden och bygg appen
COPY . ./
RUN dotnet publish -c release -o /app/publish
# versionen som ska publiceras läggs i image-appen, /app/publish 

# Steg 2: Runtime-miljö
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS final
WORKDIR /app

# kopiera från första imagen vi skapade till där vi är (funktionen av '.'')
COPY --from=build /app/publish .

# .dll filer är exekverbara
ENTRYPOINT ["dotnet", "dockerintro.dll"]