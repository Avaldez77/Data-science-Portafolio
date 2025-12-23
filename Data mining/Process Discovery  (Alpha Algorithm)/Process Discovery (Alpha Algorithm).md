<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/50464e21-52b8-4e20-89fb-372ceb2d0c25" />


# Interpretable Process Discovery from Event Logs (Alpha Algorithm)

## 🔍 Overview
This project focuses on **process discovery** using the **Alpha Algorithm (Alpha Miner)** to reconstruct an interpretable process model directly from event log data. Using **pm4py**, the workflow extracts control-flow relations from observed executions and produces a process representation that helps understand how the process actually runs in practice.

---

## 🎯 Objective
- Discover an interpretable process model from an event log  
- Reveal control-flow structure (ordering, branching, and concurrency signals) from observed behavior  
- Provide a transparent baseline model for further process analysis (e.g., conformance and performance)

---

## 🧠 Methodology
- Load and validate the event log in pm4py  
- Compute directly-follows behavior and relations required by Alpha Miner  
- Run **Alpha Miner** to discover a process model (commonly a **Petri net**)  
- Visualize and inspect the discovered model to interpret routing logic  
- Preserve intermediate outputs to maintain transparency and reproducibility

---

## 📊 Key Results
- A discovered process model that reflects observed behavior in the event log  
- Clear visibility into core execution paths and structural patterns  
- A reproducible discovery pipeline suitable as a baseline for more advanced techniques

---

## 🛠 Technologies & Skills
- Python  
- pm4py (Process Mining)  
- Alpha Algorithm / Alpha Miner  
- Event Log Handling (XES / formatted event logs)  
- Process Discovery & Model Interpretation  
- Reproducible Analytical Workflows

---

## 🧩 Why This Project Matters
Process discovery converts raw event logs into an interpretable model of how work is actually executed.  
This project demonstrates a transparent, data-driven approach to reconstruct process structure, enabling better diagnostics, stakeholder communication, and serving as a foundation for conformance checking, bottleneck analysis, and process improvement initiatives.
