pipeline {
    agent any
    
    environment {
        DB_CREDENTIALS = credentials('database-credentials')
    }
    
    stages {
        stage('Validate Migrations') {
            steps {
                script {
                    sh 'python src/scripts/migration_validator.py'
                }
            }
        }
        
        stage('Database Migration') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'database-credentials', 
                        usernameVariable: 'DB_USER', 
                        passwordVariable: 'DB_PASS'
                    )
                ]) {
                    sh '''
                        liquibase \
                        --driver=org.postgresql.Driver \
                        --classpath=/path/to/postgresql-jdbc.jar \
                        --url=jdbc:postgresql://localhost:5432/yourdb \
                        --username=$DB_USER \
                        --password=$DB_PASS \
                        --changeLogFile=src/migrations/changelog-master.xml \
                        migrate
                    '''
                }
            }
        }
    }
}