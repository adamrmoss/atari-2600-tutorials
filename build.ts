import { getCommandLineOptions, showHelp } from './command-line-options';
import { ensureOutputDirectory, buildRom, runRom } from './dasm';

const options = getCommandLineOptions();
let { help, name, run } = options;

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
