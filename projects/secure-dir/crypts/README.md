# Encryption utilities

Store in `~/secdir.enc/crypts/` any handlers for encryption. You can also define your own, and refer to it in your `./secdir.enc/config` configuration file.

Your handler must provide

* a _open_crypt command that takes a token representing the encrypted data store, and a token representing the decrypted data store
* a _close_crypt command that takes a token representing the decrypted data store for closing
* a _check_crypt command which returns code 0 if it is installed, or a non-zero code otherwise
* a _get_crypt command which prints to stdout instructions on how to install the cryptogrpahic utility of your choice

See the exampes in this directory for more information.

The default encyption utility is EncFS.
