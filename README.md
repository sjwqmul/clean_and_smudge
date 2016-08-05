# clean_and_smudge

Use clean and smudge filters to encrypt data to/from git. The filters should be embedded in any projects that use them as then each project can have its own password file.

For an example, see the [config.php](https://github.research.its.qmul.ac.uk/aaw393/standard_det/blob/master/config.php) file in the standard_det project.

Uses the openssl command to encrypt sensitive data in files. A file called "password" should be in the same folder as the scripts and will be used to encrypt/decrypt the data. OpenSSL must be installed and on the path.

clean.sh:
Looks for PHP variables called $...api... being set to a hex string. These are assumed to be API keys and the values are encrypted before being added to git.

smudge.sh:
Looks for encrypted data in the file of the format <<<ENCRYPTED=somestringofencryptedstuff>>> and decrypts the somestringofencryptedstuff

setup_filters.sh:
Configures a git repository to use the clean and smudge filters.
* Identifies the filter to be used for PHP files (modifies .gitattributes in the repository base dir)
* Identifies the clean and smudge filters (uses git config in the repository)

## Tasks
- [ ] Tweak so that a central set of clean/smudge scripts can use a password file for a project
- [ ] Generate a password file on setup if one doesn't exist
