import { getCommandLineOptions, showHelp } from './base-command-line-options';
import { ensureDirectories } from './paths';

import { ICommandLineOptions, optionsDefinitions, usageSections } from './generate/command-line-options';
import { getNumberData } from './generate/data-size';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const {
    abs, acos, acosh, asin, asinh, atan, atanh, atan2,
    cbrt, ceil, clz32, cos, cosh, exp, expm1, floor, fround,
    hypot, imul, log, log1p, log10, log2, max, min, pow,
    random, round, sign, sin, sinh, sqrt, tan, tanh, trunc,
    E, LN2, LN10, LOG2E, LOG10E, PI, SQRT1_2, SQRT2,
} = Math;

const options = getCommandLineOptions<ICommandLineOptions>(optionsDefinitions);
const { help, name, expression, length, dataSize } = options;

if (help || !expression || !name)
{
    showHelp(usageSections);
}
else
{
    ensureDirectories();

    console.log(`Generating: ${expression} as ${dataSize}s for 0 ≤ t < ${length}!`);
    const values = new Array<string>(length);
    for (let t = 0; t < length; t++)
    {
        const computedValue = Math.round(Number(eval(expression)));
        console.log(`ComputedValue: ${computedValue}`);
        const value = getNumberData(computedValue, dataSize);
        console.log(`Value: ${value}`);
        values[t] = value;
    }
}
