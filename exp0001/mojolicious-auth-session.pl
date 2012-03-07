#!/usr/bin/perl

use Mojolicious::Lite;
use Mojolicious::Plugin::Authentication;
use Mojolicious::Plugin::Bcrypt;
use Mojolicious::Plugin::Database;
use DBI;

#
# The auth database contains the user accounts
#
# Sample schema:
# CREATE TABLE user (user_id integer primary key, 
#                    user_name varchar,
#                    user_passwd varchar);
#
# The user_passwd fields contains a bcrypt hash
#

plugin 'database' => {
    dsn      => 'dbi:SQLite:dbname=auth',
    username => q{},
    password => q{},
    options  => { RaiseError => 1 },
    helper   => 'db',

};

#
# Use strong encryption
#

plugin 'bcrypt';

#
# Database-based authentication example
#

plugin 'authentication' => {

    load_user => sub {

        my ( $self, $uid ) = @_;

        my $sth = $self->db->prepare(' select * from user where user_id=? ');

        $sth->execute($uid);

        if ( my $res = $sth->fetchrow_hashref ) {

            return $res;

        }
        else {

            return;
        }

    },

    validate_user => sub {

        my ( $self, $username, $password ) = @_;

        my $sth
            = $self->db->prepare(' select * from user where user_name = ? ');

        $sth->execute($username);

        return unless $sth;

        if ( my $res = $sth->fetchrow_hashref ) {

            my $salt = substr $password, 0, 2;

            if ( $self->bcrypt_validate( $password, $res->{user_passwd} ) ) {

                $self->session(user => $username);

                #
                # For data that should only be visible on the next request, like
                # a confirmation message after a 302 redirect, you can use the
                # flash.
                #
                
                $self->flash(message => 'Thanks for logging in.');

                return $res->{user_id};

            }
            else {

                return;

            }

        }
        else {

            return;

        }
    },

};

#
# This page is visible only to authenticated users
#

any '/welcome' => sub {

    my $self = shift;

    if ( not $self->user_exists ) {

        $self->flash( message => 'You must log in to view this page' );

        $self->redirect_to('/');

        return;

    }
    else {

        $self->render( template => 'welcome' );

    }

};

#
# Try to log in the user
#

any '/login' => sub {

    my $self = shift;

    my $user = $self->param('name') || q{};

    my $pass = $self->param('pass') || q{};

    if ( $self->authenticate( $user, $pass ) ) {

        $self->redirect_to('/welcome');

    }
    else {

        $self->flash( message => 'Invalid credentials!' );

        $self->redirect_to('/');

    }

};

#
# Close the session
#

any '/logout' => sub {

    my $self = shift;

    $self->session( expires => 1 );

    $self->redirect_to('/');

};

#
# If logged in, show the welcome page
# Show the login form otherwise
#

any '/' => sub {

    my $self = shift;

    if ( $self->session('name') ) {

        return $self->redirect_to('/welcome');

    }
    else {

        $self->render( template => 'login' );

    }

};

#
# Change the default secret key for signing the cookies
# This passphrase is used by the HMAC-MD5 algorithm to make signed cookies
# secure and can be changed at any time to invalidate all existing sessions.
#

app->secret('9dd1571a116fccce362d54996c3d8c70c101cad5');

#
# Run!
#

app->start;

__DATA__
@@ layouts/default.html.ep
<!doctype html><html>
<head><title><%= title %></title></head>
<body><%= content %></body>
</html>

@@ login.html.ep
% layout 'default';
% title 'Login';
<h1>Log In</h1>
<% if (my $message = flash 'message' ) { %>
    <b><%= $message %></b><br>
<% } %>
<%= form_for login => (method => 'post') => begin %>
    Name: <%= text_field 'name' %>
    <br>
    Password: <%= password_field 'pass' %>
    <br>
    <%= submit_button 'Login' %>
<% end %>

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<% if (my $message = flash 'message' ) { %>
    <b><%= $message %></b><br>
<% } %>

@@ welcome.html.ep
% title 'Welcome page';
<% if (my $message = flash 'message' ) { %>
    <b><%= $message %></b><br>
<% } %>
Welcome <%= session 'user' %>.<br>
<%= link_to Logout => 'logout' %>
