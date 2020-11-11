import { getCommandLineOptions, showHelp } from './build/command-line-options';
import { ensureOutputDirectory, buildRom, runRom } from './build/dasm';

const options = getCommandLineOptions();
const { help, name, run } = options;

if (help || !name)
{
    showHelp();
} else
{
    ensureOutputDirectory();
    buildRom(options);

    if (run)
    {
        runRom(options);
    }
}
