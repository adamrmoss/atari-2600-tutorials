import getCommandLineOptions, { CommandLineOptions } from 'command-line-args';
import getCommandLineUsage from 'command-line-usage';
import ansi from 'ansi-escape-sequences';

import shell from './shell';
import { buildRom } from './dasm';

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

interface IOptions {
    help: boolean;
    srcPath: string;
    romPath: string;
    name: string;
}

const optionsDefinitions =
    [
        {
            name: 'help', alias: 'h',
            description: 'Display this usage guide',
            type: Boolean
        },
        {
            name: 'srcPath', alias: 's',
            description: '[bold italic]{Optional} Assembly source directory, defaults to this directory',
            type: String,
            defaultValue: '.'
        },
        {
            name: 'romPath', alias: 'r',
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

const options = getCommandLineOptions(optionsDefinitions) as IOptions;

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

    if (options.romPath)
    {
        copyOutputToRomsDirectory(options);
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

function copyOutputToRomsDirectory({ name, romPath }: { name: string, romPath: string })
{
    shell(`cp 'out/${name}.'* '${romPath}/'`);
}
