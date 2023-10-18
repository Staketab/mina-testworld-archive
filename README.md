# MINA NODE SETUP
Setup Mina Archive node for Testworld.

## 1. Clone repository:

```bash
git clone https://github.com/Staketab/mina-testworld-archive.git
cd mina-testworld-archive
```

## 2. Generate LIB_P2P and UPTIME Keystores
```bash
make setup
```

# Carefully fill in any missing fields in the .env variables file

## 3. Start
Run this command to start the node:  
```bash
make ar
```
Stop the nodes:
```bash
make ar-down
```

## Additional commands:
Check logs
```bash
make logs
```
Check node status
```bash
make status
```