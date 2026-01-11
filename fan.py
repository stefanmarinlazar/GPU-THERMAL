import pynvml
import sys

def set_gpu_fans(speed, mode):
    try:
        pynvml.nvmlInit()
        handle = pynvml.nvmlDeviceGetHandleByIndex(0)
        num_fans = pynvml.nvmlDeviceGetNumFans(handle)
        for i in range(num_fans):
            # Set Policy first: 1 = Manual, 0 = Auto
            pynvml.nvmlDeviceSetFanControlPolicy(handle, i, mode)
            if mode == 1:
                pynvml.nvmlDeviceSetFanSpeed_v2(handle, i, speed)
    except Exception as e:
        print(f"NVML Error: {e}")
    finally:
        pynvml.nvmlShutdown()

if __name__ == "__main__":
    # Usage: fan.py <speed> <mode>
    speed_val = int(sys.argv[1]) if len(sys.argv) > 1 else 60
    mode_val = int(sys.argv[2]) if len(sys.argv) > 2 else 1
    set_gpu_fans(speed_val, mode_val)
