FROM rocker/shiny:3.5.1

RUN apt-get update && apt-get install libcurl4-openssl-dev libv8-3.14-dev -y &&\
    mkdir -p /var/lib/shiny-server/bookmarks/shiny


# Download and install library
RUN R -e "install.packages(c('shinydashboard', 'reticulate', 'shiny'))"

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

RUN apt-get update
RUN apt-get install -y libpython-dev
RUN apt-get install -y libpython3-dev

# copy the app to the image
COPY shinyapps /root/app
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

# make all app files readable (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /root/app
RUN chmod -R 755 /usr/local/lib/R/etc

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/app/app.R')"]
