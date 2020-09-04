import getCommandLineOptions, { CommandLineOptions } from 'command-line-args';
import  getCommandLineUsage from 'command-line-usage';
import { execSync } from 'child_process';
import exit from 'exit';
import ansi from 'ansi-escape-sequences';

const logo =
    '              ██ █████ ██\n' +
    '              ██░█████░██\n' +
    '              ██░█████░██\n' +
    '              ██░█████░██\n' +
    '              ██░█████░██\n' +
    '              ██░█████░██\n' +
    '              ██░█████░██\n' +
    '              ██░█████░██\n' +
    '             ███░█████░███\n' +
    '            ████░█████░████\n' +
    '           █████░█████░█████\n' +
    '          █████░░█████░░█████\n' +
    '        ██████░░ █████ ░░██████\n' +
    '      ███████░░  █████  ░░███████\n' +
    '   ████████░░░   █████   ░░░████████\n' +
    '█████████░░░     █████     ░░░█████████\n' +
    '██████░░░░       █████       ░░░░██████\n' +
    ' ░░░░░░          ░░░░░          ░░░░░░\n\n' +
    '                ATARI ®';

const ansiLogo = ansi.format(logo, ['red', 'bold']);

const optionsDefinitions =
    [
        {
            name: 'help', alias: 'h',
            description: 'Display this usage guide',
            type: Boolean
        },
        {
            name: 'src', alias: 's',
            description: '[bold italic]{Optional} Assembly source directory, defaults to this directory',
            type: String,
            defaultValue: '.'
        },
        {
            name: 'roms', alias: 'r',
            description: '[bold italic]{Optional} Roms directory to copy binary output to',
            type: String
        },
        {
            name: 'name',
            description: '[bold italic]{Required} The name portion of both the assembly source and binary output',
            type: String,
            defaultOption: true
        }
    ];

const usageSections =
    [
        {
            content: ansiLogo,
            raw: true
        },
        {
            header: 'atari-2600-tutorials/build.js',
            content: 'Compile [bold]{Atari 2600} games using [bold]{dasm}'
        },
        {
            header: 'Synopsis',
            content: '$ build <options> [bold italic]{name}'
        },
        {
            header: 'Options',
            optionList: optionsDefinitions
        }
    ];

const options = getCommandLineOptions(optionsDefinitions);

if (options.help || !options.name)
{
    showHelp();
} else
{
    if (options.name.endsWith('.asm'))
    {
        options.name = options.name.replace('.asm', '');
    }
    ensureOutputDirectory();
    buildRom(options);

    if (options.roms)
    {
        copyOutputToRomsDirectory(options.name, options.roms);
    }
}

function showHelp()
{
    const usage = getCommandLineUsage(usageSections);
    console.log(usage);
}

function ensureOutputDirectory()
{
    shell('mkdir -p out');
}

function buildRom(options: CommandLineOptions)
{
    const inputFilePath       = `${options.src}/${options.name}.asm`;
    const listFilePath        = `out/${options.name}.lst`;
    const symbolFilePath      = `out/${options.name}.sym`;
    const buildOutputFilePath = `out/${options.name}.bin`;

    buildBinary(inputFilePath, listFilePath, symbolFilePath, buildOutputFilePath);
}

function buildBinary(inputFilePath: string, listFilePath: string, symbolFilePath: string, buildOutputFilePath: string)
{
    shell(`dasm ${inputFilePath} -f3 -v1 -T1 -l${listFilePath} -s${symbolFilePath} -o${buildOutputFilePath}`);
}

function copyOutputToRomsDirectory(name: string, romPath: string)
{
    shell(`cp 'out/${name}.'* '${romPath}/'`);
}

function shell(command: string)
{
    try {
        execSync(command, { stdio: 'inherit' });
    } catch {
        exit(1);
    }
}
