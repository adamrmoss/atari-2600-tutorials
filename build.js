const getCommandLineOptions = require('command-line-args');
const getCommandLineUsage = require('command-line-usage');
const exec = require('child_process').execSync;
const ansi = require('ansi-escape-sequences');

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
            content: 'Compile [bold]{Atari 2600} games using [bold]{cc65}'
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

function buildRom(options)
{
    const inputFilePath       = `${options.src}/${options.name}.asm`;
    const listFilePath        = `out/${options.name}.lst`;
    const mapFilePath         = `out/${options.name}.map`;
    const buildOutputFilePath = `out/${options.name}.bin`;

    buildBinary(inputFilePath, listFilePath, mapFilePath, buildOutputFilePath);
}

function buildBinary(inputFilePath, listFilePath, mapFilePath, buildOutputFilePath)
{
    shell(`cl65 -C atari2600.cfg -l ${listFilePath} -m ${mapFilePath} -o ${buildOutputFilePath} ${inputFilePath}`);
}

function copyOutputToRomsDirectory(name, romPath)
{
    shell(`cp 'out/${name}.'* '${romPath}/'`);
}

function shell(command)
{
    exec(command, { stdio: [0, 1, 2] })
}
