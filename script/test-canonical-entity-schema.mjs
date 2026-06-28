import fs from "node:fs";
import path from "node:path";

const buildDir = process.argv[2] || "/tmp/jethro-website-build";
const homeHtml = fs.readFileSync(path.join(buildDir, "index.html"), "utf8");
const aboutPath = fs.existsSync(path.join(buildDir, "about", "index.html"))
  ? path.join(buildDir, "about", "index.html")
  : path.join(buildDir, "about.html");
const aboutHtml = fs.readFileSync(aboutPath, "utf8");
const combinedHtml = `${homeHtml}\n${aboutHtml}`;

function fail(message) {
  console.error(message);
  process.exit(1);
}

if (combinedHtml.includes("http://localhost:4000")) {
  fail("Built pages still contain http://localhost:4000.");
}

[
  "Optimization Doc",
  "AI adoption strategist",
  "human-first AI workflow design",
  "Transformative Principal",
  "SchoolX",
  "How to Be a Transformative Principal",
  "https://optimizationdoc.com/",
  "https://transformativeprincipal.org/people/jethro-jones",
  "https://jethrojon.es/",
  "https://linkedin.com/in/jethrojones",
  "https://x.com/jethrojones",
].forEach((text) => {
  if (!aboutHtml.includes(text)) fail(`About page is missing ${text}`);
});

const scripts = [...combinedHtml.matchAll(/<script[^>]*type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi)]
  .map((match) => match[1].trim())
  .filter(Boolean)
  .map((text) => JSON.parse(text));

const graph = scripts.flatMap((entry) => entry["@graph"] || [entry]);
const person = graph.find(
  (node) =>
    node["@type"] === "Person" &&
    node["@id"] === "https://jethrojones.com/#jethro-jones",
);

if (!person) fail("Missing canonical Jethro Jones Person JSON-LD node.");
if (person.url !== "https://jethrojones.com/about") fail("Person.url does not point to /about.");
if (person.jobTitle !== "AI adoption strategist") fail("Person.jobTitle is not canonical.");
if (!person.description?.includes("Optimization Doc")) fail("Person.description does not mention Optimization Doc.");
if (!person.worksFor || person.worksFor.name !== "Optimization Doc") fail("Person.worksFor does not name Optimization Doc.");

const sameAs = new Set(person.sameAs || []);
[
  "https://linkedin.com/in/jethrojones",
  "https://x.com/jethrojones",
  "https://jethrojon.es/",
  "https://optimizationdoc.com/",
  "https://transformativeprincipal.org/people/jethro-jones",
  "https://www.wikidata.org/wiki/Q140374345",
].forEach((url) => {
  if (!sameAs.has(url)) fail(`Person.sameAs is missing ${url}`);
});

console.log("Jethro Jones canonical entity checks passed.");
