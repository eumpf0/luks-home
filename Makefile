ODIR := /usr/local/bin

.PHONY: all pam

all: ${ODIR}/noop ${ODIR}/luks-home /etc/luks-home.conf

${ODIR}/noop: noop.c
	gcc -O2 $^ -o $@

${ODIR}/luks-home: luks-home
	install -g root -o root -m 750 $^ $@

/etc/luks-home.conf: luks-home.conf
	install -g root -o root -m 644 $^ $@

pam: ${ODIR}/luks-home /etc/pam.d/system-login
	sed -i -E '/^auth\s+include\s+system-auth$$/a auth       optional   pam_exec.so          expose_authtok ${ODIR}/luks-home' /etc/pam.d/system-login
