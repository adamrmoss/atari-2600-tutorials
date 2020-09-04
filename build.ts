import { getCommandLineOptions, getCommandLineUsage } from './command-line-options';
import shell from './shell';
import { buildRom } from './dasm';

const options = getCommandLineOptions();
let { help, romPath, name } = options;

if (help || !name)
{
    showHelp();
} else
{
    normalizeName();
    ensureOutputDirectory();
    buildRom(options);

    if (romPath)
    {
        copyOutputToRomsDirectory();
    }
}

function normalizeName()
{
    if (name.endsWith('.asm'))
    {
        name = name.replace('.asm', '');
    }
}

function showHelp()
{
    const usage = getCommandLineUsage();
    console.log(usage);
}

function ensureOutputDirectory()
{
    shell('mkdir -p out');
}

function copyOutputToRomsDirectory()
{
    shell(`cp 'out/${name}.'* '${romPath}/'`);
}
