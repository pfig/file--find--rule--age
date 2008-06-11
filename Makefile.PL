use inc::Module::Install;

name     'File-Find-Rule-Age';
all_from 'lib/File/Find/Rule/Age.pm';
author   'Pedro Figueiredo <pedro.figueiredo@sns.bskyb.com>';
version  '0.2';

requires      'File::Find::Rule' => '0.30';
requires      'DateTime'         => '0.42';
test_requires 'Test::More';

auto_install;

WriteAll;

