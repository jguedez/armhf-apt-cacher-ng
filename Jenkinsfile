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
            // simple check that we can see the admin page
            sh "docker exec ${c.id} apt-get -qq update"
            sh "docker exec ${c.id} apt-get install -y --no-install-recommends curl > /dev/null"
            sh "docker exec ${c.id} curl -s http://localhost:3142/acng-report.html | grep 'Apt-Cacher NG Command And Control Page'"
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
