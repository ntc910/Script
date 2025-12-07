import psutil
import time
import csv
from datetime import datetime
import os

def get_process_by_name(process_name):
    """Find a process by its name"""
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            if proc.info['name'].lower() == process_name.lower():
                return proc
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return None

def get_network_io_for_process(pid):
    """Get network I/O counters for a specific process"""
    try:
        proc = psutil.Process(pid)
        io_counters = proc.io_counters()
        return io_counters.read_bytes, io_counters.write_bytes
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        return None, None

def monitor_hfs_network():
    """Monitor network usage for hfs.exe and save to CSV"""
    process_name = "hfs.exe"
    csv_file = "hfs_network_monitor.csv"
    
    # Check if hfs.exe is running
    hfs_process = get_process_by_name(process_name)
    if not hfs_process:
        print(f"{process_name} is not running. Please start the process first.")
        return
    
    print(f"Monitoring {process_name} (PID: {hfs_process.pid})...")
    print(f"Data will be saved to {csv_file}")
    print("Press Ctrl+C to stop monitoring.")
    
    # Initialize previous values
    prev_read, prev_write = get_network_io_for_process(hfs_process.pid)
    if prev_read is None or prev_write is None:
        print("Failed to get initial network I/O counters.")
        return
    
    # Open CSV file for writing
    with open(csv_file, 'w', newline='') as file:
        writer = csv.writer(file)
        # Write header
        writer.writerow(['timestamp', 'read_bytes', 'write_bytes', 'read_speed_kbps', 'write_speed_kbps'])
        
        try:
            while True:
                # Get current network I/O
                current_read, current_write = get_network_io_for_process(hfs_process.pid)
                if current_read is None or current_write is None:
                    print("Process may have terminated.")
                    break
                
                # Calculate speeds (in KB/s)
                time_diff = 1.0  # 1 second interval
                read_speed = (current_read - prev_read) / 1024 / time_diff
                write_speed = (current_write - prev_write) / 1024 / time_diff
                
                # Get current timestamp
                timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                
                # Write to CSV
                writer.writerow([timestamp, current_read, current_write, read_speed, write_speed])
                file.flush()  # Ensure data is written to file
                
                # Print to console
                print(f"{timestamp} - Read: {read_speed:.2f} KB/s, Write: {write_speed:.2f} KB/s")
                
                # Update previous values
                prev_read, prev_write = current_read, current_write
                
                # Wait for 1 second
                time.sleep(1)
                
        except KeyboardInterrupt:
            print("\nMonitoring stopped by user.")

if __name__ == "__main__":
    monitor_hfs_network()
