use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Memory;

use Mojo::File 'tempfile';

my $memory = CPU::Emulator::H8S::2246::Memory->new;
isa_ok $memory, 'CPU::Emulator::H8S::2246::Memory';

isa_ok $memory->bytes, 'Mojo::ByteStream';

my $file = tempfile;
$file->spurt(pack('N', 0x1234_ABCD));
$memory->from_file($file->path);
is $memory->bytes, pack('N', 0x1234_ABCD), 'right value';

done_testing;
