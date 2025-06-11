def create_recommendation_file(filename):
    with open(filename, 'w') as file:
        while True:
            chaincode = input("Enter chaincode name (or press Enter to finish): ").strip()
            if not chaincode:
                break

            ip = input("Enter IP address for the chaincode: ").strip()
            if not ip:
                print("IP address cannot be empty.")
                continue

            file.write(f"{chaincode} -> {ip}\n")
            print(f"Added: {chaincode} -> {ip}\n")

if __name__ == "__main__":
    create_recommendation_file("rekom_cc_peer.txt")
