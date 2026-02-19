const FRACTIONS = [
  { fraction: "1/2", matches: ["0.5", "0.50", "0.500"] },
  { fraction: "1/3", matches: ["0.33", "0.34", "0.333", "0.334"] },
  { fraction: "2/3", matches: ["0.66", "0.67", "0.666", "0.667"] },
  { fraction: "1/4", matches: ["0.25", "0.250"] },
  { fraction: "3/4", matches: ["0.75", "0.750"] },
  { fraction: "1/5", matches: ["0.2", "0.20", "0.200"]},
  { fraction: "2/5", matches: ["0.4", "0.40", "0.400"]},
  { fraction: "3/5", matches: ["0.6", "0.60", "0.600"]},
  { fraction: "4/5", matches: ["0.8", "0.80", "0.800"]},
  { fraction: "1/6", matches: ["0.16", "0.17", "0.166", "0.167"]},
  { fraction: "5/6", matches: ["0.84", "0.85", "0.844", "0.845"]},
  { fraction: "1/8", matches: ["0.125"]},
  { fraction: "3/8", matches: ["0.375"]},
  { fraction: "5/8", matches: ["0.625"]},
  { fraction: "7/8", matches: ["0.875"]},
  { fraction: "1/10", matches: ["0.1", "0.10", "0.100"]},
  { fraction: "3/10", matches: ["0.3", "0.30", "0.300"]},
  { fraction: "7/10", matches: ["0.7", "0.70", "0.700"]},
  { fraction: "9/10", matches: ["0.9", "0.90", "0.900"]},
  { fraction: "1/12", matches: ["0.083", "0.084"]},
  { fraction: "5/12", matches: ["0.416", "0.417"]},
  { fraction: "7/12", matches: ["0.583", "0.584"]},
  { fraction: "11/12", matches: ["0.916", "0.917"]},
  { fraction: "1/16", matches: ["0.062", "0.063"]},
  { fraction: "3/16", matches: ["0.187", "0.188"]},
  { fraction: "5/16", matches: ["0.312", "0.313"]},
  { fraction: "7/16", matches: ["0.437", "0.438"]},
  { fraction: "9/16", matches: ["0.562", "0.563"]},
  { fraction: "11/16", matches: ["0.687", "0.688"]},
  { fraction: "13/16", matches: ["0.812", "0.813"]},
  { fraction: "15/16", matches: ["0.937", "0.938"]}
];

export function toFraction(input) {
  const fractionMatch = FRACTIONS.find(f => f.matches.includes(input.trim()));
  return fractionMatch ? fractionMatch.fraction : null;
}