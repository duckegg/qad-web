
We use bootstrap as core CSS framework.

Folder bootstrap/ save original bootstrap less file. Do *NOT* change any file in this folder.





(deprecated) [Customizing Bootstrap] (http://coding.smashingmagazine.com/2013/03/12/customizing-bootstrap/)
--------------------------------------------------------------------------------

Some things to note about these files:

* `bootstrap.less`
This is the central file. It imports all of the others and is the one you'll ultimately compile.

* `reset.less`
Always the first file to be imported.

* `variables.less` and `mixins.less`
These always follow because they're dependencies for the rest. The former contains the same variables as used on the generator websites.

* `utilities.less`
This is always the last file to be imported, in order for the classes that it contains to override the rest of the styles where necessary.