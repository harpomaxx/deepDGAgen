# sNotes on Generative DGA

**Decisions**

-   Do we need to train in all bening or the domain we need to mimic?

-   Take 1 domain/hostname of the client, put it in the embedding and then generate domains similar to that. You don't care which exact domain it was.

-   If the malware 'waits' for the infected client to go to some domain, it can 'piggyback' on those requests and start generating DGA similar to them. So for a defender, its hard to know if the original webpage is doing it or the malware

-   IDEA! To optimize the DGA for the cheapest domains to register.

**Methodology**

-   The malware can access the benign domains used in the infected computer

-   Which detectors we want to avoid

    -   Humans?

        -   Should be good enough to pass a skim.

    -   DGA detection techniques: How to deal with them...

        -   `NXDOMAIN` (not now)

        -   Ratio of requests? With the GAN/gene traffic. (not now)

        -   **Domains text detection. This is our main opposition**

    -   Anom Detection.s..

        -   Do we care? Like you never used twitter?

            -   Not for now

            -   But if we have a good one... maybe

-   **Generation**

    -   Semantically similar domains

    -   Not registered

    -   Not TLd that are used. So the attacker can actually register them

-   Since we need DGA for any domain that the client is going to... it makes sense to train with domains from many benign sites.

-   Inputs

    -   Whatever you can train on

    -   From the infected machine, the top 10 most used domains/hostnames.

QUESTIONS:

**Q1: Is there any kind of domain name taxonomy?**

**Q2: Can we form clusters inside normal domains?**

**Q3: What metrics can we use to characterize a domain name?**

# **Paper Draft**

## **1. Introduction and Motivation**

What is DGA

Common methods

1.  Why is VAE better than just randomly exchanging characters on a domain following some sort of determinism (maskDGA, charBot)?

<!-- -->

2.  Why VAE is better than GANs approaches? (DeepDGA, Khaos)

Contributions:\
1.

## 2. Whole approach

### 2.1 Architecture

The different modules of the generator

### 2.3 VAE Model

### **2.4 Synchro and re adaptation (??)**

## 3. Experiment setup

### 3.1 Datasets 3.2 Metrics 3.3 Evaluation on Whois?

How can be sure a domain is registered?

### 3.3 Evaluations on Detectors 3.4 Retraining detectors?

## 4. Discussion and results

## 5. Conclusions
