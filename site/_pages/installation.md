Installing Music-Duration-Partition should be straightforward with either a CPAN client or manually.

----

# Installation using a CPAN client

## cpanminus

If you have cpanm, you only need one line:

    cpanm Music::Duration::Partition

If you are installing into a system-wide directory, you may need to pass the "-S" flag to cpanm, which uses sudo to install the module:

    cpanm -S Music::Duration::Partition

## The CPAN Shell

Alternatively, if your CPAN shell is set up, you should just be able to do:

    cpan Music::Duration::Partition

----

# Manual installation

As a last resort, you can manually install it. Download the tarball and unpack it.

Consult the file META.json for a list of pre-requisites. Install these first.

To build Music-Duration-Partition:

    perl Makefile.PL
    make && make test

Then install it:

    make install

If you are installing into a system-wide directory, you may need to run:

    sudo make install

