// TD-07c: Java SBT project with known vulnerable dependencies
name := "qscanner-test-sbt"
version := "1.0.0"
scalaVersion := "2.13.8"

libraryDependencies ++= Seq(
  // CVE-2021-44228 (Log4Shell) — CRITICAL
  "org.apache.logging.log4j" % "log4j-core" % "2.14.1",
  // CVE-2021-46877 — HIGH
  "com.fasterxml.jackson.core" % "jackson-databind" % "2.12.3"
)
