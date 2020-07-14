#!/bin/bash
istioctl manifest generate --set profile=asm-multicloud | kubectl delete -f -
