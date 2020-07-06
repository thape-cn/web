window.cultureSlideShow = function() {
    return {
        state: {
            moving: false,
            currentSlide: 1,
            looping: false,
            order: [],
            nextSlideDirection: ''
        },
        autoplayTimer: null,
        attributes: {
            direction: 'right-left',
            duration: 300,
            timer: 7000,
        },
        slides: [1,2,3,4],
        setup() {
            // Cache the original order so that we can reorder on transition (to skip inbetween slides)
            this.state.order = this.slides
            const newSlideOrder = this.slides.filter(slide_id => this.current != slide_id)
            newSlideOrder.unshift(this.current)
            this.slides = newSlideOrder

            // Start the autoslide
            this.attributes.timer && this.autoPlay()
        },
        get current() {
            return this.state.currentSlide;
        },
        get previousSlide() {
            return (this.state.currentSlide - 1) > 0 ? this.state.currentSlide - 1 : this.slides.length
        },
        get nextSlide() {
            return this.state.currentSlide < (this.slides.length - 1) ? this.state.currentSlide + 1 : 1
        },
        updateCurrent(nextSlide) {
            if (nextSlide == this.state.currentSlide) return
            if (this.state.moving) return
            this.state.moving = true

            const next = this.slides.find(slide_id => slide_id == this.state.order[nextSlide - 1])

            // Reorder the slides for a smoother transition
            const newSlideOrder = this.slides.filter(slide_id => {
                return !([this.current, this.state.order[nextSlide - 1]].indexOf(slide_id) > -1);
            })

            const activeSlides = [this.current, next]
            this.state.nextSlideDirection = nextSlide > this.state.currentSlide ? 'right-to-left' : 'left-to-right'

            newSlideOrder.unshift(...(this.state.nextSlideDirection == 'right-to-left' ? activeSlides : activeSlides.reverse()))
            this.slides = newSlideOrder
            this.state.currentSlide = nextSlide
            setTimeout(() => {
                this.state.moving = false
                // TODO: possibly a better check to determine whether autoplay should resume
                this.attributes.timer && !this.autoplayTimer && this.autoPlay()
            }, this.attributes.duration)
        },
        transitions(state) {
            const rightToLeft = this.state.nextSlideDirection === 'right-to-left'
            switch (state) {
                case 'enter':
                    return `transition ease-linear duration-300`
                case 'enter-start':
                    return rightToLeft ? 'opacity-0 transform translate-x-1/2' : 'opacity-0 transform -translate-x-1/2'
                case 'enter-end':
                    return 'opacity-100 transform translate-x-0'
                case 'leave':
                    return `absolute top-0 transition ease-in duration-300`
                case 'leave-start':
                    return 'opacity-100 transform translate-x-0'
                case 'leave-end':
                    return rightToLeft ? 'opacity-50 transform -translate-x-1/2' : 'opacity-50 transform translate-x-1/2'
            }
        },
        autoPlay() {
            this.loop = () => {
                const next = (this.state.currentSlide === this.slides.length) ? 1 : this.state.currentSlide + 1
                this.updateCurrent(this.state.looping ? next : this.currentSlide)
                this.state.nextSlideDirection = 'right-to-left';
                this.autoplayTimer = setTimeout(() => {
                    requestAnimationFrame(this.loop)
                }, this.attributes.timer + this.attributes.duration)

            }
            this.autoplayTimer = setTimeout(() => {
                this.state.looping = true
                requestAnimationFrame(this.loop)
            }, this.attributes.timer)
        },
        stopAutoplay() {
            clearTimeout(this.autoplayTimer)
            this.autoplayTimer = null
        }
    }
}
