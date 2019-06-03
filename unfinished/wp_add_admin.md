# Adding a new Wordpress admin through the database

It is fairly easy to add a new admin to a wordpress DB if you have access to the database.

For this reason, it is essential to have the appropriate permissions on the wp-config file, and limit access to the database.

## Recognize a wordpress database

* For each database, show tables
* Look for a collection of tables ending in:
	* `users`,`usermeta`,`posts`,`postmeta`,`term_relationships`,`term_taxonomy`
* --> this indicates a WP db is present; get the table prefix

The below notes presume a prefix of "wp_"; replace as necessary.

## Add a user

	insert into wp_users (user_login,user_pass,display_name) values ("new_admin",MD5('password1'),"New admin");

Keep the ID of the new user

## Convert a user to Admin

	insert into wp_usermeta (user_id,meta_key,meta_value) values ($UID,'wp_user_level',10);
	insert into wp_usermeta (user_id,meta_key,meta_value) values ($UID,"wp_capabilities",'a:1:{s:13:"administrator";b:1;}');

## Multisites

If `wp_sitemeta` exists, update the network admins

	select * from wp_sitemeta where meta_key="site_admins";

The serialization reads as follows:

* `a:2` (an array of length 2)
* `i:0;s:5:"user1";` (at index int 0, value string of length 5 "user1"; note the final semi-colon)
* `i:1;s:9:"new_admin";` (at index int 1, value string of length 9 "new_admin"; note the final semi-colon)

With this in mind, adapt the below snippet.

```sql
update wp_sitemeta set meta_value='a:2:{i:0;s:5:"user1";i:1;s:9:"new_admin";}' where meta_key="site_admins";
```
