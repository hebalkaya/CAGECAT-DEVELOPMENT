FROM ubuntu:latest
FROM python:3

RUN apt-get update
RUN apt update

RUN apt-get install -y supervisor redis zip hmmer nginx systemd nano htop cron ncdu ncbi-entrez-direct diamond-aligner zip
RUN apt install -y default-jdk

RUN pip3 install rq Flask more_itertools Flask_SQLAlchemy redis Werkzeug clinker wtforms pytz uwsgi genomicsqlite Flask-WTF ncbi-genome-download

# Install Miniconda
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x Miniconda3-latest-Linux-x86_64.sh && \
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda3

# Add Bioconda channels to download packages from
RUN /miniconda3/condabin/conda config --add channels defaults
RUN /miniconda3/condabin/conda config --add channels bioconda
RUN /miniconda3/condabin/conda config --add channels conda-forge

# Install Bioconda packages
RUN /miniconda3/condabin/conda install hmmer2 hmmer diamond fasttree prodigal blast glimmerhmm

# Install Python packages
RUN /miniconda3/bin/pip3 install jinja2==3.0.1 rq Flask more_itertools Flask_SQLAlchemy redis Werkzeug clinker wtforms pytz genomicsqlite Flask-WTF ncbi-genome-download
RUN /miniconda3/condabin/conda init

# Required for antismash
RUN pip3 install jinja2==3.0.1

# Clone your development repository
RUN git clone https://github.com/hebalkaya/CAGECAT && mv CAGECAT /repo

# Install cblaster v1.3.18
RUN pip install cblaster==1.3.18

# Install diamond v2.1.9: cblaster dependency
RUN wget http://github.com/bbuchfink/diamond/releases/download/v2.1.9/diamond-linux64.tar.gz
RUN tar xzf diamond-linux64.tar.gz

RUN mkdir /backups /pfam_db /hmm_databases /sanitization /hmm_profiles /repo/cagecat/jobs
RUN mkdir -p /process_logs/maintenance
RUN mkdir -p /root/.config/cblaster

RUN mv /repo/config_files/cagecat /etc/nginx/sites-available/cagecat

# We don't have to copy uwsgi_params, as in cagecat the /repo/config_files/uwsgi_params file is referenced to

RUN ln -s /etc/nginx/sites-available/cagecat /etc/nginx/sites-enabled

RUN chmod +x /repo/maintenance/maint_backup.sh /repo/maintenance/maint_remove_old_jobs.py

CMD ["/usr/bin/supervisord", "-c", "/repo/config_files/supervisord.conf"]
