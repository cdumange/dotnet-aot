#syntax=docker/dockerfile:1.7-labs
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.20 AS base

COPY . .

RUN dotnet build

#-------------------------------
FROM base AS api-build
RUN dotnet publish webapi -c Release -o /out

#-------------------------------
FROM base AS api-build-compiled

RUN apk update && apk upgrade
RUN apk add --no-cache clang build-base zlib-dev
RUN dotnet publish webapi -c Release --sc -o /out /p:PublishAot=true

#-------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine3.20 AS webapi
COPY --from=api-build ./out .

CMD [ "dotnet", "webapi.dll" ]

#-------------------------------
FROM alpine:3.20 AS prepare
WORKDIR /app
RUN adduser -u 1000 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM prepare AS webapi-aot
COPY --from=api-build-compiled --exclude=*.dbg  ./out .


ENV ASPNETCORE_URLS=http://0.0.0.0:5000
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

ENTRYPOINT [ "./webapi" ]

