# Set Up Open Submitter CLI

How to set up the Open Submitter Command Line Interface (CLI). The CLI is required to submit articles to services.

## Prerequisites
Please ensure the following prerequisite frameworks and applications are installed.

NPM modules need to be installed globally (npm install -g):
- [NodeJS][ca1dffb7] v4.4.7 or greater
- [PhantomJS][6997c770] v2.1 or greater
- [CasperJS][476ee510] v1.1.1 or greater
- [Cmder][9924c39d] (optional)

  [ca1dffb7]: http://nodejs.org/ "NodeJS"
  [6997c770]: http://phantomjs.org/ "PhantomJS"
  [476ee510]: http://casperjs.org/ "CasperJS"
  [9924c39d]: http://cmder.net/ "Cmder"

## Update Environment Variables
Make sure your path environment variables are updated for PhantomJS, CasperJS and Cmder with the executable path.
Depending on where you installed the software the paths will be similar to:
- C:\Program Files\nodejs\
- C:\phantomjs
- C:\casperjs\batchbin

## Check Prerequisities
After the executables paths have been added to your environment variables you can check they are installed correctly using the following commands from the command line:
- node --version
- phantomjs --version
- casperjs --version

If everything is installed correctly each command will return the curent version details.

## Download latest release of Open Submitter

Go to the releases page. Regularly check this page for new releases which include bug fixes and new features and services.

![](./img/github-release.PNG)

Download archive file (zip or tar)

![](./img/github-release2.PNG)

Extract archive to the location you want Open Submitter.

[Documentation Home][bdc43f25]

  [bdc43f25]: readme.md "Open Submitter Documentation"