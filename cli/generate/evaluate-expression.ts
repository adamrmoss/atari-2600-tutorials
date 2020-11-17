/* eslint-disable @typescript-eslint/no-unused-vars */
export function evaluateExpression(expression: string, t: number): number
{
    const {
        abs, acos, acosh, asin, asinh, atan, atanh, atan2,
        cbrt, ceil, clz32, cos, cosh, exp, expm1, floor, fround,
        hypot, imul, log, log1p, log10, log2, max, min, pow,
        random, round, sign, sin, sinh, sqrt, tan, tanh, trunc,
        E, LN2, LN10, LOG2E, LOG10E, PI, SQRT1_2, SQRT2,
    } = Math;

    return round(Number(eval(expression)));
}
