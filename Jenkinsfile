def registryName = "jguedez/apt-cacher-ng"
def registryCredential = 'dockerhub'
def dockerImage
def gitTag

node {
    stage('Clone repository') {
        checkout scm
        gitTag = sh (
            script: 'git describe --exact-match --tags 2>&1 | sed "s/^fatal: .*//"',
            returnStdout: true
        ).trim()
        echo "extracted tag: '${gitTag}'"
    }
    stage('Build image') {
        dockerImage = docker.build(registryName)
    }
    stage('Test image') {
        dockerImage.withRun() { c ->
            // simple check that an application is bound to TCP port 3142 (hex 0x0C46)
            sh "docker exec ${c.id} grep --silent 000000:0C46 /proc/net/tcp"
        }
    }
    if (!gitTag) {
        echo "not a tag, will not deploy, aborting..."
        return
    }
    stage('Deploy Image') {
        docker.withRegistry( '', registryCredential ) {
            dockerImage.push(gitTag)
            dockerImage.push("latest")
        }
    }
}
