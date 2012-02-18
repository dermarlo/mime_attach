#!/usr/bin/env perl

use strict;
use warnings;
use Email::MIME;
use constant DUMP => 'DESTINATION FOLDER'; # change this to your needs, eg: /var/www/photoblog/images
my $email = Email::MIME->new(join '', <>);

save_parts($email);

sub save_parts {
  my ($mime) = @_;
  
    return unless $mime->content_type;

  if ($mime->content_type !~ /^(text|multipart|message)/) {
      my $file = DUMP . $mime->filename(1);
      open FILE, '>', $file or die $!;
      print FILE $mime->body;
      close FILE;
      chmod 0644, $file;
      chown "www-data","www-data",$file; # change this to your needs
  }

  my @parts = $mime->parts;
    if (@parts > 1) {
        save_parts($_) for @parts;
    }
}

