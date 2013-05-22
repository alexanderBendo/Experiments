#!/usr/bin/perl

use Mojolicious::Lite;
use Cwd;

app->static->paths->[0] = getcwd;

any '/' => sub {
    shift->render_static('myfile.tgz');
};

app->start;
