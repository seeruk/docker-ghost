# Notes

New approach:

* Image is still for Ghost, and not the CLI, but won't keep any Ghost files on the image.
* Entrypoint will run checks.
    * MySQL will always be assumed to be being used.
        * Perhaps this could be a build argument?
        * Need to wait for MySQL to be ready.
    * We need to know how to check if Ghost has been installed?
        * Is this basically just directory isn't empty, or what?
        * Can the Ghost CLI be used for this? `ghost version`?
            * Should this also be used for handling upgrade?
    * Check for updates.
        * As above, can use `ghost version`?
            * Would need to pass in desired version as ENV var or something.

Or, in less details:

* Wait for MySQL
* Install Ghost if it's not installed
* Update Ghost if it's not running the right version
