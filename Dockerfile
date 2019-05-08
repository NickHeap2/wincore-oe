# extract oe1172 zip
FROM mcr.microsoft.com/windows/servercore:ltsc2016 AS OpenEdge
COPY oe1172.zip .
RUN powershell -Command Expand-Archive oe1172.zip -DestinationPath C:\Progress\OpenEdge ; \
    Remove-Item oe1172.zip

FROM mcr.microsoft.com/windows/servercore:ltsc2016

# setup chocolatey
ENV chocolateyUseWindowsCompression=false
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
RUN choco config set cachelocation C:\chococache

# install prereqs for openedge
RUN choco install \
dotnet4.6.2 \
vcredist2010 \
vcredist2015 \
--confirm \
&& rmdir /S /Q C:\chococache

# copy openedge from OpenEdge stage
COPY --from=OpenEdge C:/Progress/OpenEdge C:/Progress/OpenEdge
ENV DLC="C:\\Progress\\OpenEdge"

CMD [""]
