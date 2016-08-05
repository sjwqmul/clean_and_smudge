# clean_and_smudge

Use clean and smudge filters to encrypt data to/from git. In order to use the filters, the setup_filters.sh script should be run from the git repository they will be used in. By default, things that look like passwords or API keys will be encrypted in PHP files.

For an example, see the [config.php](https://github.research.its.qmul.ac.uk/aaw393/standard_det/blob/master/config.php) file in the standard_det project.

Uses the openssl command to encrypt sensitive data in files. A file called "password" should be in the .clean_smudge folder under the repository root folder and will be used to encrypt/decrypt the data. A random password file will be set up when the setup_filters.sh script is run. OpenSSL must be installed and on the path.

clean.sh:
Looks for PHP variables called $...api... being set to a hex string. These are assumed to be API keys and the values are encrypted before being added to git. Similarly variables called $...password... are assumed to be passwords and are encrypted.

smudge.sh:
Looks for encrypted data in the file of the format <<<ENCRYPTED=somestringofencryptedstuff>>> and decrypts the somestringofencryptedstuff

setup_filters.sh:
Configures a git repository to use the clean and smudge filters.
* Identifies the filter to be used for PHP files (modifies .gitattributes in the repository base dir)
* Identifies the clean and smudge filters (uses git config in the repository)
* Creates a default 1k random password file in $REPO/.clean_smudge
* Updates .gitignore to hide the $REPO/.clean_smudge folder

## Tasks
- [x] Tweak so that a central set of clean/smudge scripts can use a password file for a project
- [x] Generate a password file on setup if one doesn't exist
