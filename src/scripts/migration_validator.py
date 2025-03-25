import subprocess
import sys
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def validate_migration():
    try:
        # Run Liquibase validation
        result = subprocess.run([
            'liquibase', 
            '--changeLogFile=migrations/changelog-master.xml', 
            'validate'
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            logger.info("Migration validation successful")
            return True
        else:
            logger.error(f"Migration validation failed: {result.stderr}")
            return False
    
    except Exception as e:
        logger.error(f"Error during migration validation: {e}")
        return False

if __name__ == "__main__":
    if not validate_migration():
        sys.exit(1)