import { getCommandLineOptions, showHelp } from './base-command-line-options';
import { ICommandLineOptions, optionsDefinitions, usageSections } from './build/command-line-options';
import { ensureOutputDirectory, buildRom, runRom } from './build/dasm';

const options = getCommandLineOptions<ICommandLineOptions>(optionsDefinitions);
const { help, name, run } = options;

if (help || !name)
{
    showHelp(usageSections);
} else
{
    ensureOutputDirectory();
    buildRom(options);

    if (run)
    {
        runRom(options);
    }
}
