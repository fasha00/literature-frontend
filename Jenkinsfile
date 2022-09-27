def key = "app"
def server = "fasha1@103.183.74.5"
def dir = "literature-frontend"
def branch = "Production"
def image = "literature-fe"
def compose = "fe.yaml"
def rname = "origin"
def rurl = "git@github.com:fasha00/literature-frontend.git"
def duser = "fasha00"

pipeline {
    agent any
    stages{
        stage ('set remote and pull') {
            steps {
                sshagent(credentials: ["${key}"]) {
		    sh """ssh -T -o StrictHostkeyChecking=no ${server} << EOF
                    cd ${dir}
                    git remote add ${rname} ${rurl} || git remote set-url ${rname} ${rurl}
                    git pull ${rname} ${branch}
		    exit
                    EOF"""
                }
            }
        }
            
        stage ('Build Image') {
            steps {
                sshagent([key]) {
                    sh """
                          ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
                          docker build -t ${image}:v1 .
			  exit
                          EOF"""
                }
            }
        }
            
        stage ('Deploy app') {
            steps {
                sshagent([key]) {
                    sh """
                          ssh -o StrictHostkeyChecking=no ${server} << EOF
                          cd ${dir}
			  docker compose -f ${compose} down
			  docker system prune -f
                          docker compose -f ${compose} up -d
			  exit
                          EOF"""
                }
            }
        }

        stage ('Push Docker Hub') {
            steps {
                sshagent([key]) {
                   sh """
	                 ssh -o StrictHostkeyChecking=no ${server} << EOF
	                 docker image push ${duser}/${image}:v1
			 exit
	                 EOF"""
		      }
            }
        }


        stage ('Send Success Notification') {
            steps {
                sh """
                        curl -X POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' -d \
		      'chat_id=${chatid}&text=Build Number #${env.BUILD_NUMBER} literature success !'
                  """
            }
        }

    }
}
