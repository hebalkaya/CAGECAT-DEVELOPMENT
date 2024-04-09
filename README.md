# CAGECAT-DEVELOPMENT
An instructional repository to create a development environment for the bioinformatics tool CAGECAT

## Hello CAGECAT Developer!
This repository has been initiated to help you navigate through the steps for configuring your own CAGECAT development environment on WUR servers.

## General Notes
- I suggest to use Microsoft's VS Code as it supports all the features mentioned here in this documentation. You can have the full version of VS Code with your WUR (education) email.
- There is an additional instructional file on prerequisite configurations. Please check it out before starting with the instructions here.
- You need Docker rights on the server(s) you will be developing.

## Instructions
## 1. Fork your own repository on Github
### To Do
- Log in to GitHub with your credentials.
- Navigate to the main CAGECAT repository: [```main repository```](https://github.com/malanjary-wur/CAGECAT).
- Click on ```Fork``` to make your own fork.
### Notes
- You can perform this step on a browser.
- [```main repository```](https://github.com/malanjary-wur/CAGECAT): CAGECAT is primarily maintained by [Mohammad Alanjary](https://github.com/malanjary-wur), therefore, this is the main CAGECAT GitHub repository.
- If you want to work on a new version, you can fork the repository. If you will be simultaneously working on a version with a developer, then the main version developer can fork the repository and other developers can branch from that fork.
- If a new feature is ready. You can create a pull request to the ```main repository``` to have all changes/updates upstream.

## 2. Create a Docker image w/ CAGECAT-Development Dockerfile
### To Do
- Navigate to your working directory (It is advised that you work on lustre).
```
/lustre/BIF/nobackup/[username]
```
- Clone this repository & enter directory
```
git clone https://github.com/hebalkaya/CAGECAT-DEVELOPMENT.git && cd CAGECAT-DEVELOPMENT
```
- Edit [```line 33```](https://github.com/hebalkaya/CAGECAT-DEVELOPMENT/blob/974f41fb08324febc025850406304345c2ce8049/Dockerfile#L33C1-L33C71) on the Dockerfile to have your forked GitHub repository. 
- Create a docker image with the Dockerfile.
```
docker build -t cagecat-dev .
```

### Notes
- You should do this on the server.
- **Optional**: Use the terminal on VS Code to log in to the server. It will be easier to use VS Code from this point on.
- It is crucial at this step that you have same GitHub login credentials configured on your server user. Otherwise, you won't be able to commit changes.
- If you have traditionally named your fork repository CAGECAT, you only need to replace the ```https://github.com/hebalkaya/``` with your own repository. Otherwise, you also have to change the CAGECAT repo name in ```mv CAGECAT /repo```.
  E.g. if you have changed your repository name to CAGECAT-DEV: ```RUN git clone https://github.com/[username]/CAGECAT-DEV && mv CAGECAT-DEV /repo```
- ```cagecat-dev``` is the image name I use. You can change it to your liking. You might have to change it if there is already (still) an image called ```cagecat-dev```

## 3. Start up a docker container with bind mounts
### To Do
- Start up the container.
```
docker run -d \
  --name cagecat-dev-env \
  -v /lustre/BIF/nobackup/balka001/Databases:/Databases \
  -v /lustre/BIF/nobackup/alanj001/cagecat/databases:/Databases/HMM \
  -p 5364:88 \
  cagecat-dev
```
- Your containe must be running now. Check running containers.
```
docker ps
```


### Notes
- The ```--name``` flag, as clear as it is, is for the container name. You can change it to your liking.
- The ```-v``` flags indicate database bind mounts. We do not clone the databases into the container for now as they occupy a large space. Instead, they are "mirrored" with bind mounts. The container listens to them externally.
- The ```-p 5364:88``` is for port forwarding. CAGECAT is exposed on port 88 internally in the container, 5364 externally in the container.

## 4. Copy sensitive files
Sensitive files are not publicly exposed due to privacy reasons. We have to manually copy them into the container.

### To Do
- Copy the sensitive.py into the running container.
```
docker cp config_files/sensitive.py cagecat-dev-env://repo/config_files/
```
- Attach to container in VS Code (Enter the docker container).
For Mac users:
```
Command + Shift + P > Dev Containers: Attach to Running Container...
```
- Select your container to attach.
- If you don't see the files on the explorer tab:
  - Go to terminal tab, click on new terminal.
  - ```cd //repo/```
  - ``ls``: Here you must see the contents of the flask app
  - ```code .```: This will attach all the files in the repo directory to your VS Code working environment.
- Navigate to config_files > config.py and replace the domain variable from ```domain = 'https://cagecat.bioinformatics.nl/'``` to ```domain = '127.0.0.1:5364/'```.



### Notes
- These sensitive files are already included in the .gitignore. They won't be uploaded to your GitHub repository.
- Important: Do not remove these files from .gitignore as it will compramise the security of CAGECAT web server.
- The ```docker cp``` command to copy files should be run outside of the container.

## 5. Restart docker container
We need to restart the docker container 
```
docker restart cagecat_dev
```


## 5. Test configuration
If you haven't had any issues until this step, you are now ready for development.
- You can make a minor change and try committing to Github.


If everything works well and you can see your commit on your GitHub repository, you are now ready for a full blown development.

### Have fun! - hebalkaya
