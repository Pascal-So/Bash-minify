bashminify.min.sh: bashminify.sh read_args.sh expand_source.sh
	./bashminify.sh bashminify.sh > bashminify.min.sh
	chmod +x bashminify.min.sh
